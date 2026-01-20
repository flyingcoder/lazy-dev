#!/bin/bash
# documentation-validator.sh - Validates documentation organization before commits
# Ensures all documentation follows automated-documentation.mdc rules

# Configuration
VALIDATION_ERRORS=0
VALIDATION_WARNINGS=0
DOCS_DIR="docs"
RULES_DIR=".cursor/rules/workflow"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Read JSON input
json_input=$(cat)

# Extract file path from input
file_path=$(echo "$json_input" | jq -r '.file_path // .path // empty' 2>/dev/null)

# If no file path, check if it's a commit/batch operation
if [ -z "$file_path" ]; then
    # For commit operations, check all staged documentation files
    if command -v git >/dev/null 2>&1; then
        staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(md|mdc)$' || true)
        if [ -z "$staged_files" ]; then
            # No staged doc files, exit gracefully
            exit 0
        fi
    else
        # Not in git repo or git not available, skip validation
        exit 0
    fi
fi

# Validation functions
validate_location() {
    local file=$1
    local errors=0
    
    # Skip validation for files in trash (they're subject to deletion)
    if [[ "$file" =~ docs/\.trash/ ]]; then
        return 0  # Skip validation for trash files
    fi
    
    # Check if file is in docs/ or .cursor/rules/
    if [[ "$file" != docs/* ]] && [[ "$file" != .cursor/rules/**/*.mdc ]] && [[ "$file" =~ \.(md|mdc)$ ]]; then
        echo -e "${YELLOW}⚠️  WARNING: Documentation file outside docs/: $file${NC}"
        ((VALIDATION_WARNINGS++))
    fi
    
    # Check decision documents location
    if [[ "$file" =~ docs/decisions/ ]]; then
        if [[ ! "$file" =~ docs/decisions/[0-9]{3}-[a-z0-9-]+\.md$ ]]; then
            echo -e "${RED}❌ ERROR: Decision document must follow format: docs/decisions/DDD-description.md${NC}"
            echo -e "   Found: $file"
            echo -e "   Example: docs/decisions/001-triangle-architecture.md"
            ((errors++))
        fi
    fi
    
    # Check migration plan location
    if [[ "$file" =~ docs/.*MIGRATION.*PLAN\.md ]] || [[ "$file" =~ docs/.*MIGRATION.*PLAN\.md ]]; then
        if [[ ! "$file" =~ docs/[A-Z_]+_MIGRATION_PLAN\.md$ ]]; then
            echo -e "${YELLOW}⚠️  WARNING: Migration plan naming should be: docs/NAME_MIGRATION_PLAN.md${NC}"
            ((VALIDATION_WARNINGS++))
        fi
    fi
    
    return $errors
}

validate_metadata() {
    local file=$1
    local errors=0
    
    # Check if file has YAML frontmatter
    if ! head -1 "$file" | grep -q "^---$"; then
        echo -e "${RED}❌ ERROR: Missing YAML frontmatter in: $file${NC}"
        echo -e "   All documentation files must start with ---"
        ((errors++))
        return $errors
    fi
    
    # Check required metadata fields
    local has_purpose=$(grep -q "^purpose:" "$file" && echo "yes" || echo "no")
    local has_type=$(grep -q "^documentation_type:" "$file" && echo "yes" || echo "no")
    local has_status=$(grep -q "^status:" "$file" && echo "yes" || echo "no")
    
    if [ "$has_purpose" = "no" ]; then
        echo -e "${RED}❌ ERROR: Missing 'purpose:' field in: $file${NC}"
        ((errors++))
    fi
    
    if [ "$has_type" = "no" ]; then
        echo -e "${RED}❌ ERROR: Missing 'documentation_type:' field in: $file${NC}"
        echo -e "   Required values: decision|architecture|guide|reference|status|migration"
        ((errors++))
    fi
    
    if [ "$has_status" = "no" ]; then
        echo -e "${RED}❌ ERROR: Missing 'status:' field in: $file${NC}"
        echo -e "   Required values: active|deprecated|superseded"
        ((errors++))
    fi
    
    # Check status value is valid
    if [ "$has_status" = "yes" ]; then
        local status=$(grep "^status:" "$file" | head -1 | sed 's/^status:[[:space:]]*//' | tr -d '"' | tr -d "'")
        if [[ ! "$status" =~ ^(active|deprecated|superseded)$ ]]; then
            echo -e "${RED}❌ ERROR: Invalid status value in: $file${NC}"
            echo -e "   Found: $status"
            echo -e "   Required: active|deprecated|superseded"
            ((errors++))
        fi
    fi
    
    # Check documentation_type value is valid
    if [ "$has_type" = "yes" ]; then
        local doc_type=$(grep "^documentation_type:" "$file" | head -1 | sed 's/^documentation_type:[[:space:]]*//' | tr -d '"' | tr -d "'")
        if [[ ! "$doc_type" =~ ^(decision|architecture|guide|reference|status|migration)$ ]]; then
            echo -e "${RED}❌ ERROR: Invalid documentation_type value in: $file${NC}"
            echo -e "   Found: $doc_type"
            echo -e "   Required: decision|architecture|guide|reference|status|migration"
            ((errors++))
        fi
    fi
    
    return $errors
}

validate_cross_references() {
    local file=$1
    local errors=0
    
    # Check for broken relative links
    while IFS= read -r line; do
        # Match markdown links [text](path)
        if [[ "$line" =~ \[([^\]]+)\]\(([^)]+)\) ]]; then
            local link_path="${BASH_REMATCH[2]}"
            
            # Skip absolute URLs
            if [[ "$link_path" =~ ^https?:// ]] || [[ "$link_path" =~ ^# ]]; then
                continue
            fi
            
            # Resolve relative path
            local file_dir=$(dirname "$file")
            local resolved_path
            
            # Handle different path formats
            if [[ "$link_path" =~ ^\.\./ ]]; then
                resolved_path="$file_dir/$link_path"
            elif [[ "$link_path" =~ ^\./ ]]; then
                resolved_path="$file_dir/${link_path#./}"
            elif [[ "$link_path" =~ ^/ ]]; then
                resolved_path="$link_path"
            else
                resolved_path="$file_dir/$link_path"
            fi
            
            # Normalize path
            resolved_path=$(echo "$resolved_path" | sed 's|/\./|/|g' | sed 's|/[^/]*/\.\./|/|g')
            
            # Check if file exists
            if [ ! -f "$resolved_path" ] && [ ! -d "$resolved_path" ]; then
                echo -e "${YELLOW}⚠️  WARNING: Broken cross-reference in: $file${NC}"
                echo -e "   Link: [$link_path]"
                echo -e "   Resolved to: $resolved_path (not found)"
                ((VALIDATION_WARNINGS++))
            fi
        fi
    done < "$file"
    
    return $errors
}

validate_deprecation() {
    local file=$1
    local errors=0
    
    # Check if deprecated doc has replacement
    local status=$(grep "^status:" "$file" 2>/dev/null | head -1 | sed 's/^status:[[:space:]]*//' | tr -d '"' | tr -d "'")
    
    if [ "$status" = "deprecated" ]; then
        # Check for replaced_by field
        if ! grep -q "^replaced_by:" "$file"; then
            echo -e "${YELLOW}⚠️  WARNING: Deprecated document missing 'replaced_by:' field: $file${NC}"
            ((VALIDATION_WARNINGS++))
        fi
        
        # Check for deprecated_date
        if ! grep -q "^deprecated_date:" "$file"; then
            echo -e "${YELLOW}⚠️  WARNING: Deprecated document missing 'deprecated_date:' field: $file${NC}"
            ((VALIDATION_WARNINGS++))
        fi
    fi
    
    return $errors
}

validate_implementation_status() {
    local file=$1
    local errors=0
    
    # Special validation for IMPLEMENTATION_STATUS.md
    if [[ "$file" == "docs/IMPLEMENTATION_STATUS.md" ]]; then
        # Check for required sections
        if ! grep -q "^## ✅ Completed Implementation" "$file"; then
            echo -e "${YELLOW}⚠️  WARNING: IMPLEMENTATION_STATUS.md missing 'Completed Implementation' section${NC}"
            ((VALIDATION_WARNINGS++))
        fi
        
        # Check for status summary
        if ! grep -q "^\*\*Status\*\*:" "$file"; then
            echo -e "${YELLOW}⚠️  WARNING: IMPLEMENTATION_STATUS.md missing status summary${NC}"
            ((VALIDATION_WARNINGS++))
        fi
    fi
    
    return $errors
}

# Main validation function
validate_documentation_file() {
    local file=$1
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ ERROR: File not found: $file${NC}"
        ((VALIDATION_ERRORS++))
        return 1
    fi
    
    echo -e "${GREEN}📄 Validating: $file${NC}"
    
    validate_location "$file"
    ((VALIDATION_ERRORS+=$?))
    
    validate_metadata "$file"
    ((VALIDATION_ERRORS+=$?))
    
    validate_cross_references "$file"
    # Cross-reference errors are warnings only
    
    validate_deprecation "$file"
    # Deprecation errors are warnings only
    
    validate_implementation_status "$file"
    # Implementation status errors are warnings only
}

# Main execution
if [ -n "$file_path" ] && [ -f "$file_path" ]; then
    # Single file validation (from afterFileEdit hook)
    if [[ "$file_path" =~ \.(md|mdc)$ ]]; then
        validate_documentation_file "$file_path"
    fi
else
    # Batch validation (from commit/pre-commit)
    if [ -n "$staged_files" ]; then
        echo -e "${GREEN}📚 Validating staged documentation files...${NC}"
        while IFS= read -r file; do
            if [ -f "$file" ]; then
                validate_documentation_file "$file"
            fi
        done <<< "$staged_files"
    fi
fi

# Summary
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ $VALIDATION_ERRORS -eq 0 ] && [ $VALIDATION_WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ Documentation validation passed${NC}"
    exit 0
elif [ $VALIDATION_ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Documentation validation passed with $VALIDATION_WARNINGS warning(s)${NC}"
    echo -e "${YELLOW}   Warnings are non-blocking but should be addressed${NC}"
    exit 0
else
    echo -e "${RED}❌ Documentation validation failed with $VALIDATION_ERRORS error(s) and $VALIDATION_WARNINGS warning(s)${NC}"
    echo -e "${RED}   Please fix errors before committing${NC}"
    echo -e "${YELLOW}   See .cursor/rules/workflow/automated-documentation.mdc for documentation rules${NC}"
    exit 1
fi


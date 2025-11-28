class_name DMConstants extends RefCounted


const USER_CONFIG_PATH = "user://dialogue_manager_user_config.json"
const CACHE_PATH = "user://dialogue_manager_cache.json"


enum MutationBehaviour {
	Wait,
	DoNotWait,
	Skip
}

enum TranslationSource {
	None,
	Guess,
	CSV,
	PO
}

# Token types

const TOKEN_FUNCTION = &"function"
const TOKEN_DICTIONARY_REFERENCE = &"dictionary_reference"
const TOKEN_DICTIONARY_NESTED_REFERENCE = &"dictionary_nested_reference"
const TOKEN_GROUP = &"group"
const TOKEN_ARRAY = &"array"
const TOKEN_DICTIONARY = &"dictionary"
const TOKEN_PARENS_OPEN = &"parens_open"
const TOKEN_PARENS_CLOSE = &"parens_close"
const TOKEN_BRACKET_OPEN = &"bracket_open"
const TOKEN_BRACKET_CLOSE = &"bracket_close"
const TOKEN_BRACE_OPEN = &"brace_open"
const TOKEN_BRACE_CLOSE = &"brace_close"
const TOKEN_COLON = &"colon"
const TOKEN_COMPARISON = &"comparison"
const TOKEN_ASSIGNMENT = &"assignment"
const TOKEN_OPERATOR = &"operator"
const TOKEN_COMMA = &"comma"
const TOKEN_NULL_COALESCE = &"null_coalesce"
const TOKEN_DOT = &"dot"
const TOKEN_CONDITION = &"condition"
const TOKEN_BOOL = &"bool"
const TOKEN_NOT = &"not"
const TOKEN_AND_OR = &"and_or"
const TOKEN_STRING = &"string"
const TOKEN_NUMBER = &"number"
const TOKEN_VARIABLE = &"variable"
const TOKEN_COMMENT = &"comment"

const TOKEN_VALUE = &"value"
const TOKEN_ERROR = &"error"

# Line types

const TYPE_UNKNOWN = &""
const TYPE_IMPORT = &"import"
const TYPE_USING = &"using"
const TYPE_COMMENT = &"comment"
const TYPE_RESPONSE = &"response"
const TYPE_TITLE = &"title"
const TYPE_CONDITION = &"condition"
const TYPE_WHILE = &"while"
const TYPE_MATCH = &"match"
const TYPE_WHEN = &"when"
const TYPE_MUTATION = &"mutation"
const TYPE_GOTO = &"goto"
const TYPE_DIALOGUE = &"dialogue"
const TYPE_RANDOM = &"random"
const TYPE_ERROR = &"error"

# Line IDs

const ID_NULL = &""
const ID_ERROR = &"error"
const ID_ERROR_INVALID_TITLE = &"invalid title"
const ID_ERROR_TITLE_HAS_NO_BODY = &"title has no body"
const ID_END = &"end"
const ID_END_CONVERSATION = &"end!"

# Errors

const ERR_ERRORS_IN_IMPORTED_FILE = 100
const ERR_FILE_ALREADY_IMPORTED = 101
const ERR_DUPLICATE_IMPORT_NAME = 102
const ERR_EMPTY_TITLE = 103
const ERR_DUPLICATE_TITLE = 104
const ERR_TITLE_INVALID_CHARACTERS = 106
const ERR_UNKNOWN_TITLE = 107
const ERR_INVALID_TITLE_REFERENCE = 108
const ERR_TITLE_REFERENCE_HAS_NO_CONTENT = 109
const ERR_INVALID_EXPRESSION = 110
const ERR_UNEXPECTED_CONDITION = 111
const ERR_DUPLICATE_ID = 112
const ERR_MISSING_ID = 113
const ERR_INVALID_INDENTATION = 114
const ERR_INVALID_CONDITION_INDENTATION = 115
const ERR_INCOMPLETE_EXPRESSION = 116
const ERR_INVALID_EXPRESSION_FOR_VALUE = 117
const ERR_UNKNOWN_LINE_SYNTAX = 118
const ERR_TITLE_BEGINS_WITH_NUMBER = 119
const ERR_UNEXPECTED_END_OF_EXPRESSION = 120
const ERR_UNEXPECTED_FUNCTION = 121
const ERR_UNEXPECTED_BRACKET = 122
const ERR_UNEXPECTED_CLOSING_BRACKET = 123
const ERR_MISSING_CLOSING_BRACKET = 124
const ERR_UNEXPECTED_OPERATOR = 125
const ERR_UNEXPECTED_COMMA = 126
const ERR_UNEXPECTED_COLON = 127
const ERR_UNEXPECTED_DOT = 128
const ERR_UNEXPECTED_BOOLEAN = 129
const ERR_UNEXPECTED_STRING = 130
const ERR_UNEXPECTED_NUMBER = 131
const ERR_UNEXPECTED_VARIABLE = 132
const ERR_INVALID_INDEX = 133
const ERR_UNEXPECTED_ASSIGNMENT = 134
const ERR_UNKNOWN_USING = 135
const ERR_EXPECTED_WHEN_OR_ELSE = 136
const ERR_ONLY_ONE_ELSE_ALLOWED = 137
const ERR_WHEN_MUST_BELONG_TO_MATCH = 138
const ERR_CONCURRENT_LINE_WITHOUT_ORIGIN = 139
const ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES = 140
const ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE = 141
const ERR_NESTED_DIALOGUE_INVALID_JUMP = 142
const ERR_MISSING_RESOURCE_FOR_AUTOSTART = 143

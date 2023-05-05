import re
import ast
from fastapi import FastAPI

app = FastAPI()

def syntax_checker(code):
    stack = []
    opening_brackets = ['(', '[', '{', '<']
    closing_brackets = [')', ']', '}', '>']
    bracket_pairs = dict(zip(closing_brackets, opening_brackets))
    keywords = ['if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return']
    line_num = 1
    error_msg = ""

    for line in code.split('\n'):
        # Ignore comments
        line = re.sub(r'//.*', '', line)

        for word in line.split():
            if word in opening_brackets:
                stack.append((word, line_num))
            elif word in closing_brackets:
                if not stack:
                    error_msg = f"Syntax error: unexpected closing bracket '{word}' on line {line_num}."
                    break
                elif stack[-1][0] == bracket_pairs[word]:
                    stack.pop()
                else:
                    error_msg = f"Syntax error: mismatched brackets '{stack[-1][0]}' and '{word}' on lines {stack[-1][1]} and {line_num}."
                    break
            elif word in keywords:
                stack.append((word, line_num))

        line_num += 1
        if error_msg:
            break

    if stack:
        if stack[-1][0] in opening_brackets:
            error_msg = f"Syntax error: unclosed bracket '{stack[-1][0]}' on line {stack[-1][1]}."
        else:
            error_msg = f"Syntax error: expected closing bracket for '{stack[-1][0]}' on line {stack[-1][1]}."
    return not error_msg, error_msg

# example usage
code = """
int main() {
    for (int i = 0; i < 10; i++) {
        if (i % 2 == 0) {
            printf("%d is even.\n", i);
        } else {
            printf("%d is odd.\n", i);
        }
    }
    return 0;
}
"""
success, error_msg = syntax_checker(code)

@app.get("/")
async def root():
    return {"message": "Hello World"}
def analyze_syntax(code_str):
    try:
        ast.parse(code_str)
        return True, None
    except SyntaxError as e:
        return False, e.lineno
    
@app.post("/check")
async def root(code_str:str):
    success, line_number = analyze_syntax(code_str)
    if success:
        ast_tree = ast.parse(code_str)
        print("No syntax error")
        return {"1":"No Syntax error"}
    else:
        print("Syntax error on line", line_number)
        return {"Syntax error on line":line_number}
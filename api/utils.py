def clean_and_upper_string(v: str) -> str:
    # 1. Remove leading and trailing whitespace 
    cleaned_v = v.strip()
    # 2. Check if it is an empty string
    if not cleaned_v:
        raise ValueError("PID & NAME cannot consist entirely of blank characters.")  
    # 3. Check if it contains only alphanumeric characters (to prevent special characters)      
    if not cleaned_v.isalnum():
        raise ValueError("PID & NAME can only contain English letters and numbers.")
    # 4. After passing all checks, convert to uppercase and send back.
    return cleaned_v.upper()
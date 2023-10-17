# Convert full-width punctuations to half-width.
export def punc [
  input: string  # source file path
  --output(-o) = "./output.md" : string  # output file path
] {
  # read file content
  let content = open --raw $input

  print "converting full-width punctuations to half-width..."
  let replaced_content = $content
    | str replace -a "，" ", "
    | str replace -a "、" ", "
    | str replace -a "。" ". "
    | str replace -a "：" ": "
    | str replace -a "；" "; "
    | str replace -a "！" "! "
    | str replace -a "？" "? "
    | str replace -a "“" " \""
    | str replace -a "”" "\" "
    | str replace -a "《" " \""
    | str replace -a "》" "\" "
    | str replace -a "‘" " '"
    | str replace -a "’" "' "
    | str replace -a "（" " ("
    | str replace -a "）" ") "

  let final_content = $replaced_content
    | str replace -a ". \n" ".\n"
    | str replace -a ", \n" ",\n"
    | str replace -a "? \n" "?\n"
    | str replace -a "! \n" "!\n"
    | str replace -a ") \n" ")\n"
    | str replace -a ": \n" ":\n"
    | str replace -a "; \n" ";\n"
    | str replace -a ") ." ")."
    | str replace -a ") ," "),"
    | str replace -a ") ?" ")?"
    | str replace -a ") !" ")!"
    | str replace -a ") )" "))"
    | str replace -a ") :" "):"
    | str replace -a ") ;" ");"
    | str replace -a "\" ." "\"."
    | str replace -a "\" ," "\","
    | str replace -a "\" ?" "\"?"
    | str replace -a "\" !" "\"!"
    | str replace -a "\" )" "\")"
    | str replace -a "\" :" "\":"
    | str replace -a "\" ;" "\";"

  # write to target file path
  echo $final_content | save -f $output
  print $"succuess with output file: ($output)"
}
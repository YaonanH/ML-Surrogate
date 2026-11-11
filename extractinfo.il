let((emxForm field)
  emxForm = hiGetCurrentForm()

  if(emxForm then
    printf("FORM: %L\n" emxForm->hiFormSym)

    foreach(fieldName emxForm->fieldList
      field = get(emxForm fieldName)

      when(field
        printf("FIELD: %L  PROMPT: %L  TYPE: %L\n"
               fieldName field->prompt field->fieldType)

        when(stringp(field->prompt) &&
             rexMatchp("Simulation" field->prompt)
          printf("BUTTON CHOICES: %L\n" field->choices)
          printf("BUTTON CALLBACKS: %L\n" field->_callback)
        )
      )
    )
  else
    printf("No active form. Open EMX -> Simulate and click inside it.\n")
  )
)
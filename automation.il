; tl_emx_run.il
; Set this on the school server. An empty string uses the process
; file already present in the EMX form.
tlEmxProcess = ""

procedure(tlEmxSetup()
  let((form)
    form = hiGetCurrentForm()

    unless(form && member('run_EMX form->fieldList)
      error("The EMX Simulate form is not active. Click inside the popup and try again.\n")
    )

    unless(equal(tlEmxProcess "")
      form->Process->value = tlEmxProcess
    )

    ; Mesh settings from the EMX form.
    form->Edge_mesh->value = 1.0
    form->Thickness->value = 1.0
    form->Via_merge->value = 0.5
    form->_3D_metals->value = "*"

    ; Two signal ports with the M1 ground pin.
    form->Signals->value = "P1 P2"
    form->Grounds->value = "GND"
    form->Global_ref->value = nil

    ; Frequencies are in Hz. The Step field takes a string.
    form->Start->value = 9.0e10
    form->Stop->value = 1.4e11
    form->Step->value = "1e8"

    form
  )
)

procedure(tlEmxRun()
  let((form process)
    form = tlEmxSetup()
    process = form->Process->value

    unless(stringp(process) && !equal(process "")
      error("Set tlEmxProcess or enter a process file in the EMX form.\n")
    )

    start_EMX()
  )
)

procedure(tlEmxOpenAndRun()
  let((cv)
    cv = geGetEditCellView()

    unless(cv && equal(cv->cellName "tl_m7_m1")
      error("Make the tl_m7_m1 layout active before calling tlEmxOpenAndRun().\n")
    )

    show_EMX_gui(nil nil)

    ; Timer units are tenths of a second.
    hiRegTimer("tlEmxRun()" 10)
  )
)
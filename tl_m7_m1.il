; tl_m7_m1.il
; Dimensions in micrometers. Starting geometry for a 90-140 GHz EM sweep.

let((targetLib)
  targetLib = ddGetObj("ML surrogate")
  unless(targetLib
    error("tl_m7_m1: library ML surrogate is missing from this Virtuoso session.\n")
  )

  pcDefinePCell(
    list(targetLib "tl_m7_m1" "layout")
    (
      (lineLength   float 100.0)
      (signalWidth  float   4.0)
      (groundMargin float  10.0)
      (pinLength    float   2.0)
    )

    let((sigTop sigBottom gndTop gndBottom
         p2Start gndPinLeft gndPinRight gndPinTop
         pinSpecs spec netId termId pinFig)

      unless(lineLength > 0.0 && signalWidth > 0.0 &&
             groundMargin >= 0.0 && pinLength > 0.0 &&
             2.0 * pinLength < lineLength
        error("tl_m7_m1: require positive length and width, nonnegative ground margin, and 0 < pinLength < lineLength/2.\n")
      )

      sigTop = signalWidth / 2.0
      sigBottom = 0.0 - sigTop
      gndTop = sigTop + groundMargin
      gndBottom = 0.0 - gndTop

      dbCreateRect(
        pcCellView list("M7" "drawing")
        list(list(0.0 sigBottom) list(lineLength sigTop))
      )
      dbCreateRect(
        pcCellView list("M1" "drawing")
        list(list(0.0 gndBottom) list(lineLength gndTop))
      )

      p2Start = lineLength - pinLength
      gndPinLeft = (lineLength - pinLength) / 2.0
      gndPinRight = gndPinLeft + pinLength
      gndPinTop = gndBottom + min(pinLength signalWidth)

      pinSpecs = list(
        list("P1" "M7" list(list(0.0 sigBottom) list(pinLength sigTop)))
        list("P2" "M7" list(list(p2Start sigBottom) list(lineLength sigTop)))
        list("GND" "M1" list(list(gndPinLeft gndBottom)
                             list(gndPinRight gndPinTop)))
      )

      foreach(spec pinSpecs
        netId = dbMakeNet(pcCellView car(spec))
        termId = dbCreateTerm(netId car(spec) "inputOutput")
        pinFig = dbCreateRect(pcCellView list(cadr(spec) "pin") caddr(spec))
        dbCreatePin(netId pinFig car(spec) termId)
      )
    )
  )
)

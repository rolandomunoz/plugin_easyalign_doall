include ../../plugin_easyalign_doall/procedures/get_tier_number.proc
include ../../plugin_easyalign_doall/procedures/config.proc

easy_align_dir$ = "../../plugin_easyalign"
@config.init: "../../plugin_easyalign_doall/.logfile.txt"

beginPause: "2.Phonetisation : phonetize orthographic tier to phonetic tier"
  comment: "Set directories"
  sentence: "TextGrid_folder", ""
  sentence: "Folder_destiny", ""
  comment: "TextGrid tiers(s)"
  word: "ortho_tier", config.init.return$["ortho_tier"]
  word: "phono_tier", config.init.return$["phono_tier"]
  comment: "Choose a language"
  optionMenu: "language", 4
    option: "fra"
    option: "en"
    option:"spa"
    option: "spa (seseo)"
    option: "porbra"
    option: "slk"
  comment: "If phono_tier exists,"
  boolean: "overwrite_phono_tier", 1
clicked = endPause: "Continue", "Quit", 1

if clicked = 2
  exitScript()
endif

@config.setField: "ortho_tier", ortho_tier$
@config.setField: "phono_tier", phono_tier$
@config.setField: "phonetize.tgFolderDir.ouput", folder_destiny$

fileList = Create Strings as file list: "fileList", "'textGrid_folder$'/*TextGrid"
n = Get number of strings
for i to n
  tgName$ = Object_'fileList'$[i]
  tg = Read from file: textGrid_folder$ + "/" + tgName$
  # Run phonetization
  @getTierNumber: ortho_tier$
  ortho_tier = getTierNumber.return
  if !ortho_tier
    exitScript: "The TextGrid does not contain the tier 'tier$'"
  endif
  Set tier name: ortho_tier, "'ortho_tier$'.raw"
  dup_tier = if ortho_tier> 1 then ortho_tier-1 else 1 fi
  Duplicate tier: ortho_tier, dup_tier, ortho_tier$
  Replace interval text: dup_tier, 0, 0, "[^A-Za-zñáéíóú ]", "", "Regular Expressions"
  runScript: "'easy_align_dir$'/phonetize_orthotier2.praat", ortho_tier$, "phono", language$, overwrite_phono_tier, 0
  selectObject: tg
  @getTierNumber: "phono"
  phono_tier = getTierNumber.return
  Set tier name: phono_tier, phono_tier$
  Save as text file: folder_destiny$ + "/" + tgName$
  select all
  minusObject: fileList
  Remove
endfor
removeObject: fileList
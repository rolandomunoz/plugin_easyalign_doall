include ../../plugin_easyalign_doall/procedures/get_tier_number.proc
include ../../plugin_easyalign_doall/procedures/config.proc

easyalign_dir$ = "../../plugin_easyalign"
@config.init: "../../plugin_easyalign_doall/.logfile.txt"

beginPause: "3.Segmentation: create phones, syll and words tiers"
  comment: "Creates 'phones','words' tiers from a Sound and a TextGrid with 'phono' tier (and 'ortho' tier)"
  comment: "Set directories"
  sentence: "Audio_folder", ""
  sentence: "TextGrid_folder", config.init.return$["phonetize.tgFolderDir.ouput"]
  sentence: "Folder_destiny", ""
  comment: "TextGrid structure"
  sentence: "ortho_tier", config.init.return$["ortho_tier"]
  sentence: "phono_tier", config.init.return$["phono_tier"]
  boolean: "overwrite", 1
  comment: "Choose a language"
  optionMenu: "language", 3
    option: "fra"
    option: "nan"
    option: "spa"
    option: "slk"
    option: "porbra"
  word: "chars_to_ignore", "!¡}-';(),.?"
  boolean: "precise_endpointing", 1
  comment: "Variation detection"
  boolean: "consider_star", 1
  boolean: "allow_elision", 0
  comment: "After processing"
  real: "preptk_threshold", 90
  boolean: "make_syllable_tier", 1
clicked = endPause: "Continue", "Quit", 1

if clicked = 2
  exitScript()
endif

@config.setField: "ortho_tier", ortho_tier$
@config.setField: "phono_tier", phono_tier$

fileList = Create Strings as file list: "fileList", "'textGrid_folder$'/*.TextGrid"
n = Get number of strings
for i to n
  tgName$ = Object_'fileList'$[i]
  sdName$ = (tgName$ - ".TextGrid") + ".wav"
  if fileReadable(audio_folder$+"/"+sdName$)
    tg = Read from file: textGrid_folder$ + "/" + tgName$
    sd = Read from file: audio_folder$ + "/" + sdName$
    selectObject: tg
    plusObject: sd
    runScript: "'easyalign_dir$'/align_sound.praat", ortho_tier$, phono_tier$, overwrite, language$, chars_to_ignore$, precise_endpointing, consider_star, allow_elision, preptk_threshold, make_syllable_tier, 0
    selectObject: tg
    Save as text file: "'folder_destiny$'/'tgName$'"
    removeObject: sd, tg
   endif
endfor
removeObject: fileList

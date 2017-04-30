include ../../plugin_easy_align_intonation/procedures/get_tier_number.proc
easy_align_dir$ = "../../plugin_easyalign"

form Tokenize by tier
  word tier_name Phrases
endform

tg = selected("TextGrid")
sd = selected("Sound")

# Run phonetization
selectObject: tg
@getTierNumber: tier$
tier = getTierNumber.return
if !tier
  exitScript: "The TextGrid does not contain the tier 'tier$'"
endif

tier_dup = if tier > 1 then tier-1 else 1 fi
Duplicate tier: tier, tier_dup, "'tier$'.dup"
Replace interval text: tier, 0, 0, "¡", "", "Literals"
Replace interval text: tier, 0, 0, "¿", "", "Literals"
runScript: "'easyalign_path$'/phonetize_orthotier2.praat", "'tier$'.dup", "phono", "spa (seseo)", "yes", "no"

selectObject: tg
@getTierNumber: "phono"
tier_phono = getTierNumber.result

# Run tokenizer
selectObject: sd
plusObject: tg
runScript: "'easyalign_path$'\align_sound.praat", "'tier$'.dup", "phono", "yes", "spa", "!¡}-';(),.?¿", "yes", "yes", "yes", 90, "yes", "no"

select all
object_tmp = selected("Strings")
removeObject: object_tmp

selectObject: sd
plusObject: tg

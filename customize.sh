#!/system/bin/sh

[ -d "$MODPATH/system" ] || abort "! Module payload is incomplete"

label_tree() {
  SOURCE=$1
  REFERENCE=$2
  [ -d "$SOURCE" ] || return 0
  [ -e "$REFERENCE" ] || return 0
  find "$SOURCE" -print | while IFS= read -r ENTRY; do
    RELATIVE=${ENTRY#"$SOURCE"}
    LABEL_FROM=$REFERENCE$RELATIVE
    while [ ! -e "$LABEL_FROM" ] && [ "$LABEL_FROM" != / ]; do
      LABEL_FROM=${LABEL_FROM%/*}
      [ -n "$LABEL_FROM" ] || LABEL_FROM=/
    done
    chcon --reference="$LABEL_FROM" "$ENTRY" 2>/dev/null || true
  done
}

set_perm_recursive "$MODPATH/system" 0 0 0755 0644
set_perm "$MODPATH/system/bin/surfaceflinger" 0 2000 0755

label_tree "$MODPATH/system" /system
label_tree "$MODPATH/system/vendor" /vendor
ui_print "- Blur payload prepared"
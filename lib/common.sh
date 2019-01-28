quiet=false
fatal() { rc="$1"; shift; printf %s\\n "${0##*/} error: $*" >&2 || true; exit "$rc"; }
nonfatal() { $quiet || printf %s\\n "${0##*/}: $*" >&2 || true; }

_save_semver() {
    saved_semver="${semver:-}"
    saved_major="${major:-}"
    saved_minor="${minor:-}"
    saved_patch="${patch:-}"
    saved_ver_pre="${ver_pre:-}"
    saved_ver_meta="${ver_meta:-}"
    }
_unsave_semver() {
    semver="$saved_semver"
    major="$saved_major"
    minor="$saved_minor"
    patch="$saved_patch"
    ver_pre="$saved_ver_pre"
    ver_meta="$saved_ver_meta"
    }
_parse_semver() {
    semver="$1"
    case "$1" in
        [!0123456789]*) return 1 ;;
        *+) return 1 ;;
        *+*)
            ver_meta="${1#*+}"
            set -- "${1%%+*}"
            ;;
        *) ver_meta= ;;
        esac
    # TODO: better validate ver_meta
    case "$1" in
        [0123456789]*.[0123456789]*.[0123456789]*) ;;
        *) return 1 ;;
        esac
    major="${1%%.*}"
    ver_pre="${1#*.}"
    minor="${ver_pre%%.*}"
    ver_pre="${ver_pre#*.}"
    patch="${ver_pre%%-*}"
    case "$ver_pre" in
        *-) return 1 ;;
        *-*) ver_pre="${ver_pre#*-}" ;;
        *) ver_pre= ;;
        esac
    # TODO: better validate ver_pre
    case "$major$minor$patch" in *[!0123456789]*) return 1 ;; esac
    case ".$major.$minor.$patch." in
        *.0[!.]*) return 1 ;;
        esac
    }
parse_semver() {  # STR
    # sets variables: semver, major, minor, patch, ver_pre, ver_meta
    # semver 2.0.0
    _save_semver
    _parse_semver "$1" || { _unsave_semver; return 1; }
    }
set_greater_semver() {  # STR
    # if STR in semver format, parse the greater semver
    parse_semver "$1" || return 0
    [ $major -le $saved_major ] || return 0
    [ $major =   $saved_major ] || { _unsave_semver; return 0; }
    [ $minor -le $saved_minor ] || return 0
    [ $minor =   $saved_minor ] || { _unsave_semver; return 0; }
    [ $patch -le $saved_patch ] || return 0
    [ $patch =   $saved_patch ] || { _unsave_semver; return 0; }
    }

hg_is_pristine() {  # [-Rrepo]
    # "pristine" = clean without unknown files
    # hg identify doesn't consider unknown files when marking clean/dirty
    [ -z "$(hg status "$@" | head -n1)" ]
    }

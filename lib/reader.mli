
type error =
  | TrailingBytes  of string
  | WrongLength    of string
  | Unknown        of string
  | Underflow
  | Overflow       of int
  | UnknownVersion of (int * int)
  | UnknownContent of int
with sexp

module Or_error :
  Control.Or_error with type err = error
open Or_error

val parse_version     : Cstruct.t -> Core.tls_version or_error
val parse_any_version : Cstruct.t -> Core.tls_any_version or_error
val parse_record      : Cstruct.t ->
  [ `Record of (Core.tls_hdr * Cstruct.t) * Cstruct.t
  | `Fragment of Cstruct.t
  ] or_error

val parse_handshake_frame : Cstruct.t -> (Cstruct.t option * Cstruct.t)
val parse_handshake : Cstruct.t -> Core.tls_handshake or_error

val parse_alert     : Cstruct.t -> Core.tls_alert or_error

val parse_change_cipher_spec   : Cstruct.t -> unit or_error

val parse_certificate_request     : Cstruct.t -> (Packet.client_certificate_type list * Cstruct.t list) or_error
val parse_certificate_request_1_2 : Cstruct.t -> (Packet.client_certificate_type list * (Nocrypto.Hash.hash * Packet.signature_algorithm_type) list * Cstruct.t list) or_error

val parse_dh_parameters        : Cstruct.t -> (Core.dh_parameters * Cstruct.t * Cstruct.t) or_error
val parse_digitally_signed     : Cstruct.t -> Cstruct.t or_error
val parse_digitally_signed_1_2 : Cstruct.t -> (Nocrypto.Hash.hash * Packet.signature_algorithm_type * Cstruct.t) or_error

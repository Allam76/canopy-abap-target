** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcx_digits_parser_error definition public
    inheriting from cx_static_check create public.
  public section.
    data message type string.
    methods constructor importing message type string.
endclass.

class zcx_digits_parser_error implementation.
  method constructor.
    super->constructor( ).
    me->message = message.
  endmethod.
endclass.
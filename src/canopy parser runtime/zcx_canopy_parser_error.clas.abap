class zcx_canopy_parser_error definition public
    inheriting from cx_static_check create public.
  public section.
    data message type string.
    methods constructor importing message type string.
endclass.

class zcx_canopy_parser_error implementation.
  method constructor.
    super->constructor( ).
    me->message = message.
  endmethod.
endclass.
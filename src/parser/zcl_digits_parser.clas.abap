** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_digits_parser definition public
    inheriting from zcl_digits_grammar
    create public.

  public section.
    methods constructor importing input type string actions type ref to zif_digits_action.
    class-methods parse importing input type string actions type ref to zif_digits_action
                    returning value(result) type ref to zcl_canopy_parser_tree_node
                    raising zcx_digits_parser_error.
    methods parse2 importing input type string raising zcx_digits_parser_error.
    methods parse3.
    methods format_error importing input type string offset type i expected type zcl_digits_grammar=>string_string_tab.
endclass.

class zcl_digits_parser implementation.
  method constructor.
    super->constructor( ).
    me->input = input.
    input_size = strlen( input ).
    me->actions = actions.
    me->offset = 0.
    me->failure = 0.
  endmethod.

  method parse.
    data(parser) = new zcl_digits_parser( input = input actions = actions ).
    result = parser=>parse( ).
  endmethod.

  method parse2.
    result = parse( input = input ).
  endmethod.

  method format_error.
    split input at '\n' into table data(lines).
    data(line_no) = 0.
    data(position) = 0.

    while position <= offset.
      position = position + lines( lines[ line_no ] ) + 1.
      line_no = line_no + 1.
    endwhile.

    data(line) = lines[ line_no - 1 ].
    data(message) = 'Line ' && line_no + ': expected one of:\n\n'.

    data message type string.
    loop at expected into data(pair).
      message = message && |    - { pair[ 1 ] } from { pair[ 0 ] }\n|.
    endloop.
    data(number) = '' && line_no.
    while lines( number ) < 6.
      number = ' ' && number.
      message = message && '\n' && number && ' | ' && line && '\n'.
    endwhile.

    position = position - lines( line ) + 10.

    while position < offset.
      message = message && ' '.
      position = position + 1.
    endwhile.
    result = message && '^'.
  endmethod.

  method parse3.
    data(tree) = _read_( ).
    if tree ne FAILURE and offset = input_size.
      result = tree.
      return.
    endif.
    if expected->is_empty( ).
      failure = offset.
      expected->add( value stringtab( (  ) ( `<EOF>` ) ) ).
    endif.
    raise exception type lcl_parse_error
        exporting parent = new lcl_format_error( input = input  reason = failure expected = expected ).
  endmethod.

endclass.

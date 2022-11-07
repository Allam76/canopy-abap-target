** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_exps_parser definition public
    inheriting from zcl_exps_grammar
    create public.

  public section.
    methods constructor importing input type string actions type ref to zif_canopy_action.
    class-methods parse importing input type string
                                  actions type ref to zif_canopy_action optional
                    returning value(result) type ref to zcl_canopy_parser_tree_node
                    raising zcx_canopy_parser_error.
    methods parse2 importing input type string
                   returning value(result) type ref to zcl_canopy_parser_tree_node
                   raising zcx_canopy_parser_error.
    methods parse3 returning value(result) type ref to zcl_canopy_parser_tree_node
                   raising zcx_canopy_parser_error.
    methods format_error importing input type string
                                   offset type i
                                   expected type zcl_exps_grammar=>string_string_tab
                         returning value(result) type string.
endclass.

class zcl_exps_parser implementation.
  method constructor.
    super->constructor( ).
    me->input = input.
    input_size = strlen( input ).
    me->actions = actions.
    me->offset = 0.
    me->failure = 0.
  endmethod.

  method parse.
    data(parser) = new zcl_exps_parser( input = input actions = actions ).
    result = parser->parse3( ).
  endmethod.

  method parse2.
    result = parse( input = input ).
  endmethod.

  method format_error.
    split input at '\n' into table data(lines) in character mode.
    data(line_no) = 1.
    data(position) = 0.

    while position <= offset.
      position = position + strlen( lines[ line_no ] ) + 1.
      line_no = line_no + 1.
    endwhile.

    data(line) = lines[ line_no - 1 ].
    data(message) = 'Line ' && line_no && ': expected one of:\n\n'.

    loop at expected into data(pair).
      message = message && |    - { pair[ 2 ] } from { pair[ 1 ] }\n|.
    endloop.
    data(number) = '' && line_no.
    while strlen( number ) < 6.
      number = ` ` && number.
      message = message && '\n' && number && ' | ' && line && '\n'.
    endwhile.

    position = position - strlen( line ) + 10.

    while position < offset.
      message = message && ' '.
      position = position + 1.
    endwhile.
    result = message && '^'.
  endmethod.

  method parse3.
    data(tree) = _read_expression( ).
    if tree <> failure_node and offset = input_size.
      result = tree.
      return.
    endif.
    if expected is initial.
      failure = offset.
      append value stringtab( ( `exps` ) ( `<EOF>` ) ) to expected.
    endif.
    raise exception type zcx_canopy_parser_error
        exporting message = format_error( input = input offset = failure expected = expected ).
  endmethod.

endclass.

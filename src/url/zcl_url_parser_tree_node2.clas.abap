** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_url_parser_tree_node2 definition public
    inheriting from zcl_canopy_parser_tree_node create public.
public section.
        methods constructor importing text type string
        offset type i
        elements type tree_node_list_tab.
endclass.

class zcl_url_parser_tree_node2 implementation.
method constructor.
    super->constructor( text = text  offset = offset  elements = elements ).
    append value #( key = 'hostname' value = elements[ 1 ] ) to labelled.
endmethod.
endclass.

** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_url_parser_tree_node1 definition public
    inheriting from zcl_canopy_parser_tree_node create public.
public section.
        methods constructor importing text type string
        offset type i
        elements type tree_node_list_tab.
endclass.

class zcl_url_parser_tree_node1 implementation.
method constructor.
    super->constructor( text = text  offset = offset  elements = elements ).
    append value #( key = 'scheme' value = elements[ 1 ] ) to labelled.
    append value #( key = 'host' value = elements[ 3 ] ) to labelled.
    append value #( key = 'pathname' value = elements[ 4 ] ) to labelled.
    append value #( key = 'search' value = elements[ 5 ] ) to labelled.
endmethod.
endclass.

** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class cache_record definition.
  public section.
    data node type ref to zcl_digits_parser_tree_node.
    data tail type i.

    methods constructor importing node type ref to zcl_digits_parser_tree_node tail type i.
endclass.
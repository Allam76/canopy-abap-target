** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class cache_record definition
  public create public.
    public section.
        data node type ref to lcl_tree_node.
        data tail type i.

        methods constructor exporting node type ref to tree_node tail type i.
endclass.

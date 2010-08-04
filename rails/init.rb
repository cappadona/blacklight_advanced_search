require 'blacklight_advanced_search'

# Require the Blacklight plugin to be installed
config.plugins = 'blacklight'

# Require the RubyTree gem which is needed for query parsing
config.gem 'rubytree', :lib => 'tree', :version => '0.5.2'

config.after_initialize do
  BlacklightAdvancedSearch.init
  
  Blacklight.config[:search_fields] << {:display_label => 'Advanced', :key => BlacklightAdvancedSearch.config[:search_field], :include_in_simple_select => false} if defined? :Blacklight


  # Do these things in a to_prepare block, to try and make them work
  # in development mode with class-reloading. The trick is we can't
  # be sure if the controllers we're modifying are being reloaded in
  # dev mode, if they are in the BL plugin and haven't been copied to
  # local, they won't be. But we do our best. 
  config.to_prepare do
    # Ordinary module over-ride to CatalogController
    CatalogController.send(:include,  
        BlacklightAdvancedSearch::ControllerOverride  
    ) unless
      CatalogController.include?(   
        BlacklightAdvancedSearch::ControllerOverride 
      )

    # Add helpers to CatalogController and SearchHistoryController. Use
    # some tricks to only add our helper once, may need to be done differently
    # in Rails3. 
    CatalogController.add_template_helper(
      BlacklightAdvancedSearch::RenderConstraintsOverride 
    ) unless 
        CatalogController.master_helper_module.include?(
          BlacklightAdvancedSearch::RenderConstraintsOverride
        )
        
    CatalogController.add_template_helper(
      BlacklightAdvancedSearch::CatalogHelperOverride 
    ) unless
      CatalogController.master_helper_module.include?( 
        BlacklightAdvancedSearch::CatalogHelperOverride 
      )
      
  
    SearchHistoryController.add_template_helper(
      BlacklightAdvancedSearch::RenderConstraintsOverride 
    ) unless
      SearchHistoryController.master_helper_module.include?( 
        BlacklightAdvancedSearch::RenderConstraintsOverride 
      )

  end
end




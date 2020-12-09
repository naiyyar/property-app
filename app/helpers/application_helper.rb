module ApplicationHelper
	
	def flash_class(flash_type)
    case flash_type.to_sym
      when :notice  then 'alert alert-success'
      when :info    then 'alert alert-info'
      when :error   then 'alert alert-danger'
      when :warning then 'alert alert-warning'
    end
  end

  def screen_class
    browser.device.mobile? ? 'screen-sm' : 'screen-lg'
  end

  # logo image
  def alt_text
    'No Fee Apartments For Rent In NYC | Transparentcity.co'
  end

  def search_placeholder_input_helper
    text_field_tag 'search-input-placeholder', 
                    searched_term, 
                    class: "border-top-lr-radius border-bottom-lr-radius #{search_placeholder_input_form_ctrl_class}", 
                    placeholder: search_input_placeholders, 
                    style: search_placeholder_input_styles, 
                    readonly: true
  end

  def home_page?
    controller_name == 'home' && action_name == 'index'
  end

  def about_page?
    action_name == 'about'
  end
  
  def addvertise_page?
    action_name == 'advertise_with_us'
  end
  
  def contribute_page?
    action_name == 'contribute'
  end

  def authentication_page?
    controller_name == 'sessions' || controller_name == 'registrations'
  end

  def seo_title_after_pipe
    action_name == 'show' ? 'Transparentcity' : 'All No Fee Apartments'
  end

  def saved_buildings_page?
    action_name == 'saved_buildings'
  end

  def mob_header_bg_color_class_helper
    if search_page? || building_show_page? || management_show_page?
      'bg-blue'
    else
      'bg-white'
    end
  end

  # showing white header with logo
  def hide_search_bar?
    hide_hood_dropdown?
  end

  def hide_hood_dropdown?
    !(search_page? || building_show_page? || management_show_page?)
  end

  def current_user_profile_image
    @current_user_profile_image ||= current_user.profile_image(session[:provider])
  rescue
    nil
  end

  def search_bar(status)
    @search_bar_hidden == status ? 'hidden' : ''
  end

  def show_filters?
    params[:searched_by].present? || params[:filter].present? || params[:sort_by].present?
  end

  def search_page? 
    show_filters?
  end

  def blog_view?
    params[:controller].include?('buttercms')
  end

  def building_show_page?
    action_name == 'show' && controller_name == 'buildings'
  end

  def management_show_page?
    action_name == 'show' && controller_name == 'management_companies'
  end

  def header_center_col
    show_filters? ? '7' : '9'
  end

  def header_right_col
    show_filters? ? '4' : '2'
  end

  def clear_link_from_right
    show_filters? ? '6' : '13'
  end

  def current_view
    show_filters? ? 'split-view' : 'other-view'
  end

	def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def show_full_width_footer?
    @half_footer ? false : true
  end

  def layout_stylesheet_link sheet_path
    if browser.chrome?
      stylesheet_link_tag sheet_path, media: 'all', rel: 'preload', as: 'style', onload: "this.rel='stylesheet'"
    else
      stylesheet_link_tag sheet_path, media: 'all'
    end
  end

  private
  def search_placeholder_input_styles
    return 'border: 0px solid #333; -webkit-appearance: none;' if screen_class == 'screen-sm' 
    'border: 0px solid #333; -webkit-appearance: none; box-shadow: 1px 1px 5px rgba(0,0,0,0.6);'
  end

  def search_placeholder_input_form_ctrl_class
    home_page? ? 'form-control' : ''
  end

end

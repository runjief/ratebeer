module ApplicationHelper
  def edit_and_destroy_buttons(item)
    unless current_user.nil?
      edit_path = 
        case item
        when Beer
          edit_beer_path(item)
        when Brewery
          edit_brewery_path(item)
        when Style
          edit_style_path(item)
        when User
          edit_user_path(item)
        when BeerClub
          edit_beer_club_path(item)
        else
          nil
        end
      
      edit = edit_path ? link_to('Edit', edit_path, class: "btn btn-primary") : ""
      
      del = if current_user&.admin?
        link_to('Destroy', item, method: :delete, 
                form: { data: { turbo_confirm: "Are you sure?" } },
                class: "btn btn-danger")
      else
        ""
      end
      
      raw("#{edit} #{del}")
    end
  end
  def round(number)
    number_with_precision(number, precision: 1)
  end
end
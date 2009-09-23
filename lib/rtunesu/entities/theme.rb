module RTunesU
  # A visual theme for iTunesU pages. Color values are in 6 digit hex (e.g. #ffffff)
  class Theme < Entity
    composed_of :background_color, :line_color, :link_arrow_color, :link_background_color,
                :link_background_color_alpha, :link_box_color, :link_text_color, :link_title_color,
                :regular_text_color, :title_text_color, :time_format, :date_format
  end
end
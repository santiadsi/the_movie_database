class Movie < ApplicationRecord

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :sorted_by_date
    ]
  )

  scope :sorted_by, ->(sort_option) {
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at/
      order("movies.created_at #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :search_query, lambda { |query|
    return nil  if query.blank?
    query = query.to_s
    terms = query.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }

    conds = Array.new
    conds.push("LOWER(movies.title) LIKE ?")
    conds.push("LOWER(movies.overview) LIKE ?")
    conds.push("LOWER(movies.vote_count) LIKE ?")

    where(
      terms.map { |term|
        conds.join(" OR ")
      }.join(' AND '),
      *terms.map { |e| [e] * conds.length }.flatten
    )
  }

  
  scope :sorted_by_date, ->(value) {
    if value.present?
      case value
      when 1
        today = Time.now
        tomorrow = today + 1.day
        where(release_date: tomorrow)
      when 2
        now = DateTime.current
        where(release_date: now.next_week..now.next_week.end_of_week)
      when 3
        now = DateTime.current
        where(release_date: now.next_month.beginning_of_month..now.next_month.end_of_month)
      end
    end
  }
end

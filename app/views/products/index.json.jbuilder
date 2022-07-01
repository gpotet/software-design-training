@products.group_by { |product| product.kind + 's' }.each do |kind, products|
  json.set! kind do
    json.array! products do |product|
      json.title product.title
      json.kind product.kind
      case product.kind
      when 'book' then json.partial! 'products/book_details', book: product
      when 'image' then json.partial! 'products/image_details', image: product
      when 'video' then json.partial! 'products/video_details', video: product
      end
    end
  end
end

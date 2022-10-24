json.id @product.id
json.title @product.title
json.kind @product.kind
json.content @product.content
json.price @product.price
json.in_library @in_library
case @product.kind
when 'book' then json.partial! 'products/book_details', book: @product
when 'image' then json.partial! 'products/image_details', image: @product
when 'video' then json.partial! 'products/video_details', video: @product
end

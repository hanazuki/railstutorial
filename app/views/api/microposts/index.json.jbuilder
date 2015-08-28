json.array! @microposts do |micropost|
  json.partial! micropost, locals: {request: request}
end

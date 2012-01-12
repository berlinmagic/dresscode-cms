# encoding: utf-8
Array.class_eval do
  
  def paginate(*args)
    page = args.first || 1
    per_page = args[1] || 5
    page_count = self.count / per_page
    stuff = self[((page - 1) * per_page)...(page * per_page)]    #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    return stuff
  end
  
end
---
layout: false
---

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "jfo.click"
  xml.subtitle ""
  xml.id "http://blog.jfo.click"
  xml.link "href" => "http://blog.jfo.click"
  xml.link "href" => "http://blog.jfo.click", "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  blog.articles[0..5].each do |article|
    if article.tags.include? "rc"
      xml.entry do
        xml.title article.title
        xml.link "rel" => "alternate", "href" => "http://blog.jfo.click" + article.url
        xml.id "http://blog.jfo.click" + article.url
        xml.published article.date.to_time.iso8601
        xml.updated article.date.to_time.iso8601
        xml.author { xml.name "Article Author" }
        xml.content article.body, "type" => "html"
      end
    end
  end
end

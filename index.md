---
#
# By default, content added below the "---" mark will appear in the home page
# between the top bar and the list of recent posts.
# To change the home page layout, edit the _layouts/home.html file.
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
#
layout: home
---

<ul>
  {% for post in site.posts %}
    <ol type="1">
      <a href="{{ post.url }}">{{ post.title }}</a> – <small>{{ post.date | date: "%B %-d, %Y" }}</small>
    </ol>
  {% endfor %}
</ul>

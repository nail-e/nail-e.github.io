---
layout: home
permalink: /posts/
---
# **Posts**

{% assign last_year = "" %}
{% assign counter = 1 %}

{% for post in site.posts %}
  {% assign current_year = post.date | date: "%Y" %}
  
  {% if current_year != last_year %}
    {% assign last_year = current_year %}
    {% assign counter = 1 %}
    {{ current_year }} 
  {% endif %}
  
  <ol start="{{ counter }}">
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a> –
      <small>{{ post.date | date: "%B %-d, %Y" }}</small>
    </li>
  </ol>

  {% assign counter = counter | plus: 1 %}
{% endfor %}


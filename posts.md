---
layout: home
permalink: /posts/
---
# **Posts**

<ol>
  {% assign last_year = "" %}
  {% for post in site.posts %}
    {% assign current_year = post.date | date: "%Y" %}
    {% if current_year != last_year %}
      <h2>{{ current_year }}</h2>
      {% assign last_year = current_year %}
    {% endif %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a> –
      <small>{{ post.date | date: "%B %-d, %Y" }}</small>
    </li>
  {% endfor %}
</ol>


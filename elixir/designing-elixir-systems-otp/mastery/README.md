# Mastery

Quiz generator.

A _quiz_ can have _templates_ in various _categories_ that create _questions_.

For example, for an addition problem the template might be `<%=left%>+<%=right%>`
with [0,1,2,3,4,5,6,7,8,9] being valid values for left and right. This means,
a quiz might generate `3+2` or ´0+0`.

As we ask questions we track the user's _responses_ and we keep generating
questions until our user masters the template. Once they get three in a row
right, we'll let them move on to the next category.

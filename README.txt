= RTunesU

== DESCRIPTION:
RTunesU is a ruby library for accessing Apple's iTunes U Webservices to integrate your education institutions iTunes U account into ruby applications. iTunes U's Webservices interface is fairly primitive by today's standards for XML based APIs.  Some known flaws of iTunes U
 * No arbitrary search
 * Queries for missing objects return an XML document representing the entire institution instead of returning an error
 * Does not follow REST principles
 * Does not use HTTP status codes meaningfully
 * Collections not contained in an outer element

== FEATURES/PROBLEMS:
 - TODO: file uploading
 
== SYNOPSIS:
see the wiki for more information on using RTunesU: 
http://github.com/trek/rtunesu/wikis

== REQUIREMENTS:
RTunesU depends on the ruby-hmac, hpricot, and builder libraries. These should all install automatically as dependencies when installing RTunesU

== INSTALL:
RTunesU install via rubygems with
   gem instal rtunesu

== LICENSE:

(The MIT License)

Copyright (c) 2008 Trek Glowacki

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
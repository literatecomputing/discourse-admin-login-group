# **Discourse Admin Login Group** Plugin

**Plugin Summary**

Use at your own risk. If it were to be used in production, it should really have some specs to make sure it's workin as expected, especially since it has to do with security.

Adds a site setting for groups that can use `/u/admin-login` to have a login link sent, allowing members of those groups to bypass SSO to login with a link.

It was proposed in [this topic](https://meta.discourse.org/t/login-for-staff-and-moderators-after-enabling-sso/327685). 

Overriding security stuff isn't a very good idea, and I was annoyed that I couldn't figure
out how to call `super` to call the original fucntion, but I gave up. And then they (wisely)
decided on another solution.

Written as an exercise, mostly, in how to override functions in a controller. 



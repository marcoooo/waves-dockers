#!/bin/bash
# Add user script for container

iadmin -V mkuser testuser rodsuser
iadmin -V mkuser testshareuser rodsuser
iadmin -V mkuser testotheruser rodsuser
iadmin -V moduser testuser password testuser
iadmin -V moduser testshareuser password testshareuser
iadmin -V moduser testotheruser password testotheruser

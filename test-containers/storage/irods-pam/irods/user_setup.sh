#!/bin/bash
# Add user script for container

iadmin -V moduser testuser password testuserpam
iadmin -V moduser testshareuser password testshareuserpam
iadmin -V moduser testotheruser password testotheruserpam

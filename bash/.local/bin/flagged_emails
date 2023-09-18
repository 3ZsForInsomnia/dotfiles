#!/usr/bin/env python3
import json
import os
import subprocess

import requests

ZAP_URL = os.getenv("ZAP_EMAIL_TO_TRELLO") or ""


def zap_webhook(email):
    author = email.get("authors")
    subject = email.get("subject")
    requests.get(ZAP_URL, params={"from": author, "subject": subject})


def get_emails():
    handle = subprocess.run(
        [
            "notmuch",
            "search",
            "--format=json",
            "--limit=5",
            "tag:flagged",
            "and",
            "tag:unread",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    raw_emails = handle.stdout.decode("utf-8")
    return json.loads(raw_emails)


emails = get_emails()
for email in emails:
    zap_webhook(email)

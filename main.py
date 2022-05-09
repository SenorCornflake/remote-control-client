#!/usr/bin/env python

import os
import requests
import typer
import json
import urllib.parse
import time

from typing import List

app = typer.Typer()

url = typer.Option(..., help="The server's url")

@app.command()
def get(identifier: str, url: str = url):
    result = requests.post(
        url + "/wp-json/rcs/v1/route",
        data = {
           "request_type": "get",
           "identifier": identifier,
       }
    )

    response = json.loads(result.text)

    typer.echo(response)

@app.command()
def set(identifier: str, commands: List[str], url: str = url):
    data = {
       "request_type": "set",
       "identifier": identifier,
    }

    for i, v in enumerate(commands):
        v = urllib.parse.quote_plus(v, safe="")
        data["commands[{}]".format(i)] = v

    result = requests.post(
        url + "/wp-json/rcs/v1/route",
        data = data
    )

    response = json.loads(result.text)

    typer.echo(response)

@app.command()
def remove(identifier: str, commands: List[str], url: str = url):
    data = {
       "request_type": "remove",
       "identifier": identifier,
    }

    for i, v in enumerate(commands):
        v = urllib.parse.quote_plus(str(v), safe="")
        data["commands[{}]".format(i)] = v

    result = requests.post(
        url + "/wp-json/rcs/v1/route",
        data = data
    )

    response = json.loads(result.text)

    typer.echo(response)

@app.command()
def listen(identifier: str, interval: int = typer.Option(5, help="Amount of time between intervals"), url: str = url):
    while True:
        typer.echo("Polling")
        result = requests.post(
            url + "/wp-json/rcs/v1/route",
            data = {
               "request_type": "get",
               "identifier": identifier,
           }
        )

        commands = json.loads(result.text)["commands"]

        if len(commands) > 0:
            for i, v in enumerate(commands):
                v = urllib.parse.unquote_plus(v)
                typer.echo("Running {}".format(v))
                os.system(v)

                data = {
                   "request_type": "remove",
                   "identifier": identifier,
                }

                data["commands[{}]".format(i)] = str(i)

                result = requests.post(
                    url + "/wp-json/rcs/v1/route",
                    data = data
                )

                typer.echo(result.text)

        time.sleep(interval)

if __name__ == "__main__":
    app()

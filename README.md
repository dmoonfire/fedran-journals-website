# Journals of Fedran Website

This repository contains the source files for generating the [Journals of Fedran](https://journals.fedran.com/) website.

## Stories and Covers Link

There are two variables in `Local.make` which are based on a local environment. These would have to be changed for a given setup.

## Generating

The basic generation is simple and uses Makefiles.

	make generate

Uploading is also pretty simple, however it requires a SSH key to the website, which is not provided.

	make upload

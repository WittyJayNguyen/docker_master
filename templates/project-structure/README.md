# Project Structure Template

This template shows the recommended project structure
to prevent Docker from auto-creating unwanted directories.

## For WordPress projects:
projects/[platform-name]/
  ├── wordpress/          <-- Mount point
  ├── docs/
  └── README.md

## For Laravel projects:
projects/[platform-name]/
  ├── web/               <-- Mount point
  ├── docs/
  └── README.md

## For HTML projects:
projects/[platform-name]/
  ├── html/              <-- Mount point
  ├── docs/
  └── README.md

# Simple-Slices
Priority-based resource division via simple categories

**Note: This project is not ready for production yet! File names and features may be renamed or removed without warning!**

**Note: Until further notice, it is strongly recommended to purge older versions before installing newer versions.**

## Basic Explanation

This package defines 8 categories ("slices") which each have a priority level that determines which categories are given access to system resources first. The categories and their priorities were chosen based on what seemed to work well for most systems and users, but these can be customized if desired. Because it is based on priority, the performance of a category is only limited when the system must already limit performance; this package allows you to choose which services are limited first, with the end result being that important services perform better.

Which services are "important" is for the user to decide, whether that be (for example) faster games or faster web hosting. By assigning commands and services to a category, they are automatically given the corresponding priority level. Instructions for usage and more technical information can be viewed by running "man simple-slices", but know that this package has been specifically designed to be simple and easy to use.

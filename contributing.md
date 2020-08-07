## Guide

If you don't see your idea listed, and you think it fits into the goals of this library, do the following:

0. Find an issue that you are interested in addressing or a feature that you would like to add.
1. Fork the repository associated with the issue to your local GitHub organization. This means that you will have a copy of the repository under `your-GitHub-username/repository-name`.
2. Clone the repository to your local machine using `git clone https://github.com/beamkenya/ex_pesa.git`
3. Create a new branch for your fix using `git checkout -b your-branch-name-here`.
4. Make the appropriate changes for the issue you are trying to address or the feature that you want to add.
5. Use `git add insert-paths-of-changed-files-here` to add the file contents of the changed files to the "snapshot" git uses to manage the state of the project, also known as the index.
6. Use `git commit -m "Insert a short message of the changes made here"` to store the contents of the index with a descriptive message.
7. Push the changes to the remote repository using `git push origin your-branch-name-here`.
8. Submit a pull request to the upstream repository.
9. Title the pull request with a short description of the changes made and the issue or bug number associated with your change. For example, you can title an issue like so "Added more log outputting to resolve #4352".
10. In the description of the pull request, explain the changes that you made, any issues you think exist with the pull request you made, and any questions you have for the maintainers. It's OK if your pull request is not perfect (no pull request is), the reviewer will be able to help you fix any problems and improve it!
11. Wait for the pull request to be reviewed by a maintainer.
12. Make changes to the pull request if the reviewing maintainer recommends them.
13. Celebrate your success after your pull request is merged!

## Testing

Make sure you write tests to any `module` or `function` you add. Also add `doctests`

## Style guide

Ensure you run `mix format` to format the code to the best standards and limit failure when the CI runs.

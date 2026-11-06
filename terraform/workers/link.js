const redirects = {
  "/": "https://pulsate.dev",
  "/discord": "https://discord.gg/NmczMnWGvh",
  "/github": "https://github.com/pulsate-dev/",
  "/x": "https://x.com/pulsate_dev",
  "/twitter": "https://x.com/pulsate_dev",
  "/fediverse": "https://mi.growthers.dev/@pulsate",
  "/youtube": "https://youtube.com/@pulsate-dev",
  "/discussions": "https://github.com/orgs/pulsate-dev/discussions",
};

export default {
  fetch(request) {
    const { pathname } = new URL(request.url);
    const isReadMethod = request.method === "GET" || request.method === "HEAD";
    // Object.hasOwn avoids resolving inherited keys such as "/constructor".
    const destination =
      isReadMethod && Object.hasOwn(redirects, pathname)
        ? redirects[pathname]
        : undefined;

    if (destination === undefined) {
      return new Response("404 Not Found", { status: 404 });
    }
    return Response.redirect(destination, 302);
  },
};

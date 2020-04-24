function highlightNav() {
  const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
          const id = entry.target.getAttribute('id');
          if (entry.intersectionRatio > 0) {
              document.querySelector(`.section-nav-container li a[href="#${id}"]`).parentElement.classList.add('active');
          } else {
              document.querySelector(`.section-nav-container li a[href="#${id}"]`).parentElement.classList.remove('active');
          }
      });
  });

  // Track all h2 tags that have an `id` applied
  document.querySelectorAll('h2[id]').forEach((h2) => {
      observer.observe(h2);
  });
}

// In case the document is already rendered
if (document.readyState != 'loading') highlightNav();
else document.addEventListener('DOMContentLoaded', highlightNav);


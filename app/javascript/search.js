document.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("search-box");
  const resultsList = document.getElementById("results");
  const title = document.getElementById("top-searches-title");
  let debounceTimer;

  input.addEventListener("input", () => {
    const keyword = input.value.trim();

    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      if (keyword.length === 0) {
        resultsList.innerHTML = "";
        title.style.display = "none";
        return;
      }

      fetch("/search_inputs", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ keyword: keyword })
        })
        .then((res) => res.json())
        .then((data) => {
          resultsList.innerHTML = "";

          if (data.length === 0) {
            resultsList.innerHTML = "<li class='no-results'>No searches found</li>";
            title.style.display = "none";
            return;
          }

          title.textContent = "Top Searches";
          title.style.display = "block";

          data.forEach((item) => {
            const li = document.createElement("li");
            li.classList.add("keyword-item");
            li.textContent = item;

            const detailsDiv = document.createElement("div");
            detailsDiv.className = "keyword-details";
            detailsDiv.style.display = "none";

            li.appendChild(detailsDiv);
            resultsList.appendChild(li);

            li.addEventListener("click", () => {
              const isVisible = detailsDiv.style.display === "block";

              // Close all others
              document.querySelectorAll(".keyword-details").forEach(div => {
                div.style.display = "none";
                div.innerHTML = "";
              });

              if (isVisible) return;

              fetch(`/search_inputs/${encodeURIComponent(item)}`)
                .then((res) => res.json())
                .then((data) => {
                  detailsDiv.innerHTML = `
                    <div class="details-card">
                      <p><strong>Occurrences:</strong> ${data.occurrences}</p>
                      <p><strong>Created:</strong> ${new Date(data.created_at).toLocaleString()}</p>
                      <p><strong>Updated:</strong> ${new Date(data.updated_at).toLocaleString()}</p>
                    </div>
                  `;
                  detailsDiv.style.display = "block";
                })
                .catch((err) => {
                  console.error("Error fetching details:", err);
                  detailsDiv.innerHTML = `<p class="error">Could not load details</p>`;
                  detailsDiv.style.display = "block";
                });
            });
          });
        })
        .catch((err) => {
          console.error("Search error:", err);
        });
    }, 500);
  });
});


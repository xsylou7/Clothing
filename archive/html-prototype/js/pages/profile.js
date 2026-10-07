import { getState, stats } from "../state.js";
import { escapeHtml } from "../ui.js";

export function renderProfile(root) {
  const { profile, weather } = getState();
  const s = stats();

  root.innerHTML = `
    <div class="page">
      <p class="page-kicker">Compte</p>
      <h1 class="page-title">Profil</h1>

      <div class="profile-head" style="margin-top:20px">
        <div class="avatar" aria-hidden="true">${escapeHtml(profile.initials)}</div>
        <div>
          <div class="profile-name">${escapeHtml(profile.firstName)}</div>
          <div class="profile-style">${escapeHtml(profile.mainStyle)}</div>
        </div>
      </div>

      <div class="stat-row">
        <div class="stat"><div class="stat-value">${s.clothes}</div><div class="stat-label">Vêtements</div></div>
        <div class="stat"><div class="stat-value">${s.looks}</div><div class="stat-label">Looks</div></div>
        <div class="stat"><div class="stat-value">${s.favorites}</div><div class="stat-label">Favoris</div></div>
      </div>

      <section class="section">
        <div class="section-head"><h3 class="section-title">Mon style</h3></div>
        <div class="chip-row">
          ${profile.styleTags
            .map(
              (tag) =>
                `<span class="chip style-chip ${tag.includes("CASUAL") && !tag.includes("SMART") ? "is-active" : ""}">${escapeHtml(tag)}</span>`
            )
            .join("")}
        </div>
        <p class="muted" style="margin-top:12px;font-size:.88rem">
          Secondaires : ${profile.secondaryStyles.map(escapeHtml).join(" · ")}
        </p>
      </section>

      <section class="section">
        <div class="section-head"><h3 class="section-title">Couleurs favorites</h3></div>
        <div class="chip-row">
          ${profile.favoriteColors.map((c) => `<span class="chip">${escapeHtml(c)}</span>`).join("")}
        </div>
      </section>

      <section class="section">
        <div class="section-head"><h3 class="section-title">Mes préférences</h3></div>
        <div class="pref-list">
          ${profile.preferences
            .map(
              (p) => `
            <div class="pref-item">
              <span>${escapeHtml(p.label)}</span>
              <span>${escapeHtml(p.value)}</span>
            </div>`
            )
            .join("")}
          <div class="pref-item">
            <span>Météo (démo)</span>
            <span>${weather.temp}°C · ${escapeHtml(weather.label)}</span>
          </div>
        </div>
      </section>
    </div>
  `;
}

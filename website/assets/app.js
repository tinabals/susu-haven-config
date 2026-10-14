(() => {
  'use strict';
  const version = document.body.dataset.version;
  if (version === 'v2') {
    document.getElementById('version-badge').textContent = 'VERSION 2';
    document.getElementById('hero-title').innerHTML = 'Small steps.<br><em>New beginnings.</em>';
    document.getElementById('hero-description').textContent = 'A fresh reminder for today: you can take your time and take your next step. Both can be true.';
    document.getElementById('welcome-strip').textContent = 'Today’s reminder: you are allowed to begin again.';
    document.getElementById('feature-title').textContent = 'There is room for a new beginning.';
    document.getElementById('feature-excerpt').textContent = 'You don’t have to wait for a perfect day to start again. Begin with what you have, right where you are.';
    document.querySelector('[data-article="becoming"]').dataset.article = 'beginning';
  }
  const sets = [
    [{id:'keep',tag:'For courage',text:'Keep going.',detail:'The next small step counts too.'},{id:'matter',tag:'For your heart',text:'You matter.',detail:'Your worth is bigger than today’s results.'},{id:'step',tag:'For perspective',text:'One step at a time.',detail:'You don’t have to do it all at once.'}],
    [{id:'rest',tag:'For rest',text:'Take a breath.',detail:'Make a little room for yourself today.'},{id:'begin',tag:'For a new day',text:'You can begin again.',detail:'Start from where you are.'},{id:'kind',tag:'For kindness',text:'Be gentle with yourself.',detail:'You’re learning as you go.'}]
  ];
  const articles = {
    becoming:{title:'You don’t have to rush your becoming.',paragraphs:['Sometimes we look at where we want to be and forget how much we have already learned along the way.','Today, growth might look like trying again. It might look like asking for help or giving yourself time to understand something new.','Choose one small next step. You don’t have to turn your whole life around before the day ends.']},
    beginning:{title:'There is room for a new beginning.',paragraphs:['A new beginning doesn’t always arrive with a big announcement. Sometimes it starts with a small decision to try again.','You can take what you learned from yesterday without carrying every disappointment into today.','What is one thing you would like to begin? Give it a little time and one honest next step.']},
    rest:{title:'Rest is something you can make room for.',paragraphs:['Pause for a moment. Let your shoulders relax. Take a comfortable breath.','There will often be something else to do. You can make room for a short pause without waiting for an empty task list.','What could a little rest look like today? A walk, a quiet cup of tea, or a few minutes away from your screen?']},
    faith:{title:'Bring the ordinary things to God too.',paragraphs:['Prayer can include the things that make up an ordinary day: your work, your plans, your questions and your conversations.','You don’t need perfect words to begin. Tell God what is on your heart.','Take a quiet moment. What would you like to bring to Him today?']}
  };
  const read = (key, fallback) => { try { const item=localStorage.getItem(key); return item===null?fallback:item; } catch { return fallback; } };
  const write = (key, value) => { try { localStorage.setItem(key,value); return true; } catch { return false; } };
  let saved;
  try { saved = JSON.parse(read('dami-haven-saved','[]')); if(!Array.isArray(saved))saved=[]; } catch { saved=[]; }
  let setIndex=0;
  const heart='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" aria-hidden="true"><path d="M12 20 4 12C-2 6 6 0 12 6c6-6 14 0 8 6Z"/></svg>';
  function renderQuotes(){
    const grid=document.getElementById('quote-grid');grid.replaceChildren();
    sets[setIndex].forEach(q=>{
      const card=document.createElement('article');card.className='quote-card';
      const top=document.createElement('div');top.className='card-top';
      const tag=document.createElement('span');tag.className='category';tag.textContent=q.tag;
      const button=document.createElement('button');button.className='save-button';button.type='button';button.innerHTML=heart;
      const update=()=>{const on=saved.includes(q.id);button.setAttribute('aria-pressed',String(on));button.setAttribute('aria-label',(on?'Unsave':'Save')+' reminder: '+q.text);};update();
      button.addEventListener('click',()=>{saved=saved.includes(q.id)?saved.filter(id=>id!==q.id):[...saved,q.id];const stored=write('dami-haven-saved',JSON.stringify(saved));update();document.getElementById('quote-status').textContent=stored?(saved.includes(q.id)?'Reminder saved in this browser.':'Reminder removed from your saved list.'):'Selection updated for this visit. This browser could not save it.';});
      top.append(tag,button);const quote=document.createElement('blockquote');quote.textContent=q.text;const detail=document.createElement('p');detail.textContent=q.detail;card.append(top,quote,detail);grid.append(card);
    });
  }
  renderQuotes();
  document.getElementById('refresh-quotes').addEventListener('click',()=>{setIndex=(setIndex+1)%sets.length;renderQuotes();document.getElementById('quote-status').textContent='Three more reminders for your day.';});
  const note=document.getElementById('journal-note');note.value=read('dami-haven-note','');
  document.getElementById('save-note').addEventListener('click',()=>{document.getElementById('note-status').textContent=write('dami-haven-note',note.value)?'Your note is saved in this browser on this device.':'Your note is here for this visit, but this browser could not save it.';});
  document.getElementById('clear-note').addEventListener('click',()=>{note.value='';const ok=write('dami-haven-note','');document.getElementById('note-status').textContent=ok?'Your saved note has been cleared.':'Cleared on this page. Browser storage could not be updated.';note.focus();});
  const dialog=document.getElementById('reflection-dialog');let opener;
  document.querySelectorAll('[data-article]').forEach(button=>button.addEventListener('click',()=>{opener=button;const article=articles[button.dataset.article];document.getElementById('dialog-title').textContent=article.title;const content=document.getElementById('dialog-content');content.replaceChildren();article.paragraphs.forEach(text=>{const p=document.createElement('p');p.textContent=text;content.append(p);});dialog.showModal();}));
  const close=()=>dialog.close();document.getElementById('close-dialog').addEventListener('click',close);document.getElementById('done-reading').addEventListener('click',close);dialog.addEventListener('close',()=>{if(opener)opener.focus();});
})();

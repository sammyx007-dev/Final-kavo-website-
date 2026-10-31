(() => {
"use strict";
const cfg=window.KAVO_CONFIG||{},$=s=>document.querySelector(s);
$("#year").textContent=new Date().getFullYear();
$("#menu").addEventListener("click",()=>$("#nav").classList.toggle("open"));
document.querySelectorAll("#nav a").forEach(a=>a.addEventListener("click",()=>$("#nav").classList.remove("open")));
document.querySelectorAll("[data-service]").forEach(a=>a.addEventListener("click",()=>{const s=document.querySelector('[name="service"]');if(s)s.value=a.dataset.service;}));
let db=null;
try{if(window.supabase?.createClient)db=window.supabase.createClient(cfg.SUPABASE_URL,cfg.SUPABASE_ANON_KEY);}catch(e){console.error(e);}
async function publicContent(){
 if(!db)return;
 try{const {data,error}=await db.from("services").select("name,description,active,sort_order").eq("active",true).order("sort_order");if(!error&&data?.length){const root=$("#servicesList");root.replaceChildren();data.forEach((s,i)=>{const a=document.createElement("article"),ic=document.createElement("i"),h=document.createElement("h3"),p=document.createElement("p"),l=document.createElement("a");ic.textContent=["⌘","▦","✧","◷","◇","⌁"][i%6];h.textContent=s.name;p.textContent=s.description||"";l.href="#booking";l.textContent="Discuss this service ↗";l.addEventListener("click",()=>{const sel=document.querySelector('[name="service"]');if(sel)sel.value=s.name;});a.append(ic,h,p,l);root.append(a);});}}catch(e){console.warn(e);}
 try{const {data,error}=await db.from("projects").select("title,category,description,image_url,project_url,active,sort_order").eq("active",true).order("sort_order");if(!error&&data?.length){const root=$("#projectsList");root.replaceChildren();data.forEach(p=>{const a=document.createElement("article"),im=document.createElement("img"),d=document.createElement("div"),lab=document.createElement("label"),h=document.createElement("h3"),desc=document.createElement("p");im.src=p.image_url||"";im.alt=p.title+" preview";lab.textContent=p.category||"PROJECT";h.textContent=p.title;desc.textContent=p.description||"";d.append(lab,h,desc);if(p.project_url){const link=document.createElement("a");link.href=p.project_url;link.target="_blank";link.rel="noopener";link.textContent="View project ↗";d.append(link);}a.append(im,d);root.append(a);});}}catch(e){console.warn(e);}
}
publicContent();
$("#bookingForm").addEventListener("submit",async e=>{
 e.preventDefault();const form=e.currentTarget,status=$("#bookingStatus"),button=form.querySelector("button"),fd=new FormData(form),v=Object.fromEntries(fd.entries());
 if(!v.name.trim()||!v.email.trim()||!v.service||!v.details.trim()){status.textContent="Please complete all required fields.";return;}
 button.disabled=true;button.textContent="Sending enquiry…";let saved=false;
 if(db){try{const {error}=await db.from("bookings").insert([{name:v.name.trim(),email:v.email.trim(),phone:v.phone||null,service:v.service,budget:v.budget||null,start_date:v.start_date||null,details:v.details.trim(),status:"new"}]);if(!error)saved=true;else console.error(error);}catch(err){console.error(err);}}
 const msg=["Hello KAVO Technologies, I would like to make a project enquiry.",`Name: ${v.name}`,`Email: ${v.email}`,`Phone: ${v.phone||"Not supplied"}`,`Service: ${v.service}`,`Budget: ${v.budget||"Not specified"}`,`Preferred start: ${v.start_date||"Not specified"}`,`Project details: ${v.details}`].join("\n");
 status.textContent=saved?"Enquiry saved. WhatsApp will open so you can also send the details directly.":"WhatsApp will open with your enquiry. Press Send in WhatsApp to submit it.";
 status.className=saved?"ok":"notice";form.reset();button.disabled=false;button.textContent="Send project enquiry →";
 window.open(`https://wa.me/${cfg.WHATSAPP_NUMBER||"2348020737884"}?text=${encodeURIComponent(msg)}`,"_blank","noopener,noreferrer");
});
})();
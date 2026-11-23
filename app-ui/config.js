

window.CFG = {
  url: "https://xouparnbklikidrmstfa.supabase.co",
  key: "sb_publishable_axqj_r8A-P7vZRZuYrh4kg_kJ_W4ZqS"
};

window.__GROQ_VAULT = ['REkyNFFDczY2aENFaTlfa3Nn', 'eU1nTFlGM2J5ZEdXNnRYTVFv', 'bWF5ODl4UDlKa3dNTTNVaWNZ', 'M0M='];


window.getGroqKey = function(){
  try{
    return window.__GROQ_VAULT.map(function(c){
      var s = atob(c);
      return s.split('').reverse().join('');
    }).join('');
  }catch(e){ return ''; }
};

window.getGroqUrl = function(){
  return ['https://','api','.groq','.com','/openai/v1/chat/completions'].join('');
};

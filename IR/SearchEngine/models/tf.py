from model import Model

class Tf(Model):
  def __init__(self):
     super().__init__()
     pass

  def __call__(self, normal_form, normal_request, term_idx):
    document_tf = self.get_tf(normal_form, term_idx)
    request_tf = self.get_tf(normal_request, term_idx)

    doc_norms = self.norm(document_tf)
    req_norms = self.norm(request_tf)

    return self.get_relevance(req_norms, doc_norms)
class JumbotronComponentPreview < ViewComponent::Preview
  def default
    render JumbotronComponent.new(title:"Hello, world!",slogan:"This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.",body:"It uses utility classes for typography and spacing to space content out within the larger container.",link:"#",link_text:"Learn more")
  end
end
